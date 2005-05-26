From: Filip Sneppe <filip.sneppe@gmail.com>
Subject: Re: [PATCH] bring ct_sync up-to-date with 2.4.30
Date: Thu, 26 May 2005 15:04:01 +0200
Message-ID: <9151ac2a05052606041b4e6bfb@mail.gmail.com>
References: <1116877042.1848.9.camel@xbox>
	<1117109883.4551.4.camel@nienna.balabit>
Reply-To: Filip Sneppe <filip.sneppe@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@sch.bme.hu>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <1117109883.4551.4.camel@nienna.balabit>
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

On 5/26/05, KOVACS Krisztian <hidden@sch.bme.hu> wrote:
>
>   Thanks a lot for the patch, I'll try to commit this to the Netfilter
> SVN tree. BTW, the Linux 2.4 version of ct_sync has been abandoned, and
> currently we're working on the 2.6 version only. It's available from the
> Netfilter SVN repository:
>=20
> http://svn.netfilter.org/netfilter/branches/netfilter-ha/linux-2.6
>=20
>   Snapshots in an easy-to-apply form are available here:
>=20
> http://people.netfilter.org/hidden/ct_sync/snapshots/
>=20
>   Thanks a lot for trying out ct_sync and providing an updated patch.

OK, I only found out about 2.6 support yesterday when going through the=20
netfilter-failover list archives (I now realize I should have sent the patc=
h to
this list too), but will give it a try asap.

Two small questions though:
- Are there currently major differences between 2.4 and 2.6 ct_sync ?
- Is the TODO issue about conntrack/nat helpers and expected connections
  and ct_sync currently blocked because noone knows how to solve the
  problem yet, or do you know how to tackle the problem, but haven't found =
the
  time to write the code yet ?

Thanks!

Regards,
Filip
