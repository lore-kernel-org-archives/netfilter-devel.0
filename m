From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: [PATCH] bring ct_sync up-to-date with 2.4.30
Date: Thu, 26 May 2005 14:18:03 +0200
Message-ID: <1117109883.4551.4.camel@nienna.balabit>
References: <1116877042.1848.9.camel@xbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <1116877042.1848.9.camel@xbox>
To: Filip Sneppe <filip.sneppe@gmail.com>
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

2005-05-23, h keltez=E9ssel 21.37-kor Filip Sneppe ezt =EDrta:
> I played around with ct_sync this weekend, and got it to work with
> a 2.4.30 kernel. I have created an update patch for the current svn
> repository and would be happy if someone could review this and, if
> the patch looks ok, apply it. Thanks!

  Thanks a lot for the patch, I'll try to commit this to the Netfilte=
r
SVN tree. BTW, the Linux 2.4 version of ct_sync has been abandoned, a=
nd
currently we're working on the 2.6 version only. It's available from =
the
Netfilter SVN repository:

http://svn.netfilter.org/netfilter/branches/netfilter-ha/linux-2.6

  Snapshots in an easy-to-apply form are available here:

http://people.netfilter.org/hidden/ct_sync/snapshots/

  Thanks a lot for trying out ct_sync and providing an updated patch.

--=20
KOVACS Krisztian <hidden@sch.bme.hu>
