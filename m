From: Juha Heljoranta <juha.heljoranta@evtek.fi>
Subject: Re: [rfc] ipt_owner.c improvements
Date: Wed, 09 Mar 2005 14:59:06 +0200
Message-ID: <422EF31A.3060904@evtek.fi>
References: <4227B908.4070900@evtek.fi> <4228F0DD.7030307@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4228F0DD.7030307@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> Juha Heljoranta wrote:
>=20
>> I'd like to make few improvements to ipt_owner.c or perhaps to create=20
>> something new that is like owner match.
>>
>> First I'd like to improve performance for incoming packet matches. The=
=20
>> next thing is to reliably identify sending/receiving process. Last=20
>> proposal is to improve performance when matching is done several times=
=20
>> per packet.
>=20
>=20
> As Dave Miller pointed out, the only sensible thing to do is add new
> hooks to the protocols themselves, anything else is racy. The main
> challenges are making sure incoming connections using protocols that
> support sockets aren't confirmed before they survived the socket
> hooks, with all possible module combinations, and possibly hooks for
> outgoing packets, I haven't thought about that very much.

I've been skimming through the code and concluded that the fastest and=20
most reliable way to find a task receiving packet is to copy=20
sock_def_readable and modify it to fit into job.

I'm not exactly sure what you mean by adding new hooks to protocols but=20
I think that the this could be it (the hook for tcp and udp). Right?

I don't expect any race conditions to exist (famous last words) because=20
all what we are performing is just crippled version of sock_def_readable.

As I stated before sunrpc=B8 samba, bluetooth, x25, etc. reassign callbac=
k=20
functions which means that things _might_ not work as expected when=20
using them. Any way, I think that this is separate issue, we are not=20
trying to find tasks that use samba but task that use tcp or udp, right?

To get an idea what will happen when modified version of=20
sock_def_readable is issued (simplified and no locking):

void foo(struct sock *sk)
{
	if (sk->sk_sleep && waitqueue_active(sk->sk_sleep)) {
		list_for_each_safe(tmp, next,
			&sk->sk_sleep->task_list) {
			...
		}
	}
	/* for finding SIGIO targets */
	bar(sk->sk_socket->fasync_list)
}

void bar(struct fasync_struct *fa)
{
	while (fa) {
		baz(&fa->fa_file->f_owner);
		fa =3D fa->fa_next;
	}
}

void baz(struct fown_struct *fown)
{
	pid =3D fown->pid;
	if (pid > 0) {
		p =3D find_task_by_pid(pid);
		if (p)
			...
	} else {
		do_each_task_pid(-pid, PIDTYPE_PGID, p) {
			...
		} while_each_task_pid(-pid, PIDTYPE_PGID, p);
	}
}

There is still case of multicast to deal with (locate all receiving=20
struck sock *sk and issue foo(sk) for each).

Regards,
Juha Heljoranta
