From: tomasz.maj@teldom.pl
Subject: RE: connlimit patch crashes 2.6.11 kernel
Date: Wed, 18 May 2005 09:50:06 +0200 (CEST)
Message-ID: <59441.212.77.105.138.1116402606.squirrel@poczta.teldom.pl>
References: <428A4DEB.8010803@trash.net>
	<20050517203253Z4930396-6071+430@kps6.test.onet.pl>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, 'Patrick McHardy' <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20050517203253Z4930396-6071+430@kps6.test.onet.pl>
To: "Mateusz Pluta" <mateusz@republika.pl>
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

Hello,

Yes, I've got the same problem as Mariusz, my kernel 2.6.11 crashes when =
I
use connlimit patch.

Greetings
Tomek


>> Mateusz wrote:
>>> Problem does not occur when I don't apply connlimit patch to
> kernel.
>>>
>>> [<c0318777>] imq_nf_queue+0xc7/0x1a0
>>
>> Does the problem occur without the imq patch?
>>
>> Regards
>> Patrick
>
> Yes, I use imq patch, and in crash time packets problably go
> through
> the imq device, because I use it to traffic shaping.
>
> One other person found my post, and report me the same problem.
>
> Best regards, Mateusz Pluta
>
>
