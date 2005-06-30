From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: REDIRECT changes DST address of the packet
Date: Thu, 30 Jun 2005 10:08:55 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0506301007180.22412@bizon.gios.gov.pl>
References: <20050630072756.89120.qmail@web60820.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-685446075-1120118935=:22412"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Venkata Narayana <mesg2nari@yahoo.com>
In-Reply-To: <20050630072756.89120.qmail@web60820.mail.yahoo.com>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-685446075-1120118935=:22412
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 30 Jun 2005, Venkata Narayana wrote:

>
> Hello,
>
> My question is if I use REDIRECT action in
> NAT PREROUTING table  is it going to change the tcp
> packet DST address.
>
> If I lose original DST address, how can I persist
> that value in that packet.

Please use getsockopt() with SO_ORIGINAL_DST.

Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-685446075-1120118935=:22412--
