From: "=?ISO-8859-1?Q?S=E9bastien_LAVEZE?=" <slaveze@gmail.com>
Subject: Re: Libnetfilter_conntrack problems
Date: Fri, 12 May 2006 10:34:01 +0200
Message-ID: <ca021ab30605120134p552496f3i5ebd2f7c0a05b191@mail.gmail.com>
References: <ca021ab30604270455q5cf093c9s990558209bca3e1d@mail.gmail.com>
	<20060501175353.GD5267@rama>
	<ca021ab30605030249s62ab1924uf9b1be924bd2d28e@mail.gmail.com>
	<20060503111549.GO16562@sunbeam.de.gnumonks.org>
	<ca021ab30605090806l791e6f3dl7354bd789df209ee@mail.gmail.com>
	<4460B14E.90506@eurodev.net>
	<ca021ab30605100118u16675c7au933a464ebe64d705@mail.gmail.com>
	<ca021ab30605100600k5bfbe4faob771b62d50e35575@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Pablo Neira Ayuso" <pablo@eurodev.net>
In-Reply-To: <ca021ab30605100600k5bfbe4faob771b62d50e35575@mail.gmail.com>
Content-Disposition: inline
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

Hi,
I applied the patch that fixes ARM parsing problem
Now the conntrack utility works !
I'm tracking forwarded connection (my system does nat and forwarding)
Here are the results i get  with the conntrack utility

conntrack -E -e UPDATE (it works fine)

[UPDATE] tcp      6 60 SYN_RECV src=3D192.168.32.42 dst=3D172.16.16.16 spor=
t=3D48004
dport=3D21 src=3D172.16.16.16 dst=3D192.168.31.39 sport=3D21 dport=3D48004
 [UPDATE] tcp      6 432000 ESTABLISHED src=3D192.168.32.42 dst=3D172.16.16=
.16 sport
=3D48004 dport=3D21 src=3D172.16.16.16 dst=3D192.168.31.39 sport=3D21
dport=3D48004 [ASSURED]
 [UPDATE] tcp      6 120 FIN_WAIT src=3D192.168.32.42 dst=3D172.16.16.16 sp=
ort=3D48004
 dport=3D21 src=3D172.16.16.16 dst=3D192.168.31.39 sport=3D21 dport=3D48004
 [UPDATE] tcp      6 60 CLOSE_WAIT src=3D192.168.32.42 dst=3D172.16.16.16 s=
port=3D4800
4 dport=3D21 src=3D172.16.16.16 dst=3D192.168.31.39 sport=3D21 dport=3D4800=
4
 [UPDATE] tcp      6 30 LAST_ACK src=3D192.168.32.42 dst=3D172.16.16.16 spo=
rt=3D48004
dport=3D21 src=3D172.16.16.16 dst=3D192.168.31.39 sport=3D21 dport=3D48004
 [UPDATE] tcp      6 120 TIME_WAIT src=3D192.168.32.42 dst=3D172.16.16.16 s=
port=3D4800
4 dport=3D21 src=3D172.16.16.16 dst=3D192.168.31.39 sport=3D21 dport=3D4800=
4

But if i do conntrack -E -e DESTROY
I never get any events for the same connection as i did with the UPDATE eve=
nts

So apparently there is no problem to use multiple callbacks in
different processes but there is a problem with DESTROY events for TCP
connections

For my application it's fine as now i'm working with  connections
states instead of waiting for  destroy events

If you want me to do more tests I'm ok with that.

Thanks

Sebastien


On 5/10/06, S=E9bastien LAVEZE <slaveze@gmail.com> wrote:
> I guess the problem is having two event handles on two different
> processes and this might cause some strange behaviour. (I also have
> destroy events that come 5 mn after the expiration of the TIME_WAIT
> timer...)
> Has someone ever tried that ??
> Maybe it should be safer to have only one process listening to ALL
> events and then to dispatch them..
> Is there a way to make the difference between UPDATE and DESTROY
> events with a single callback listening to ALL different ?? (type
> field maybe ?)
>
> Thanks
> Sebastian
>
