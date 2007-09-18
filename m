From: Patrick McHardy <kaber@trash.net>
Subject: Re: Netfilter List cross-subscription
Date: Tue, 18 Sep 2007 13:25:22 +0200
Message-ID: <46EFB5A2.2080606@trash.net>
References: <46EE6679.3000103@trash.net> <46EE6956.10608@trash.net>
	<46EE9BE7.30306@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Received: from stinky.trash.net ([213.144.137.162]:34431 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbXIRLb4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Sep 2007 07:31:56 -0400
In-Reply-To: <46EE9BE7.30306@plouf.fr.eu.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <http://lists.netfilter.org/pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Pascal Hambourg wrote:
> Hello,
>=20
> Patrick McHardy a =E9crit :
>=20
>>
>> The cross-subscription appears to work, unfortunately (due to the
>> subscriber-only posting settings of the old list) senders to the
>> new lists that are not subscribed to the old one will receive a
>> "held for moderator approval" mail for each post.
>=20
>=20
> By the way, do the new netfilter lists at vger.kernel.org require tha=
t
> the sender address be subscribed too ? (this post will test)


No, thats one of the reasons for the move (the other one being
the overhead of manual moderation).

>=20
>> Since this is
>> probably quite annoying for everyone, I'm not sure whether we
>> should really do the cross-subscription thing.
>>
>> Any better ideas or suggestions?
>=20
>=20
> What about removing the subscriber-only posting setting on the old li=
sts
> at lists.netfilter.org ?
>=20
> PS : Messages posted to the new lists are received on the old lists, =
but
> it seems to me that messages posted to the old lists are not received=
 on
> the new lists. Is this on purpose ?


Yes, it would loop otherwise I guess. Anyways, I'm going to remove
the cross subscription and add an auto-response on the old list
telling people about the move.

> PPS : Where are the archives on lists.netfilter.org ? It now says
> "forbidden".


Thats fallout from the move to Debian. Should be fixed soon.
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
