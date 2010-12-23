From: Stephen Clark <sclark46@earthlink.net>
Subject: Re: inconsistent address treatment.
Date: Thu, 23 Dec 2010 17:45:19 -0500
Message-ID: <4D13D0FF.1010900@earthlink.net>
References: <4D1358C0.4060704@earthlink.net> <4D13A863.70600@plouf.fr.eu.org>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-junco.atl.sa.earthlink.net ([209.86.89.63]:36081 "EHLO
	elasmtp-junco.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193Ab0LWWpV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Dec 2010 17:45:21 -0500
In-Reply-To: <4D13A863.70600@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12/23/2010 02:52 PM, Pascal Hambourg wrote:
> Hello,
>
> Stephen Clark a =E9crit :
>   =20
>> Why the inconsistency in the way addresses are treated. I can use -d
>> 2.2.2.2/32
>>    but not --to-source 205.201.149.214/32
>>     =20
> Because -d takes a prefix and --to-source takes an address range.
>   =20

So? you can't parse

205.201.149.214/32-205.201.149.218/32


--=20

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
