From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: view nat mappings
Date: Thu, 2 Feb 2006 21:34:53 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0602022133160.26901@bizon.gios.gov.pl>
References: <43E21484.3060400@earthlink.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-2020069243-1138912493=:26901"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: sclark46@earthlink.net
In-Reply-To: <43E21484.3060400@earthlink.net>
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

---187430788-2020069243-1138912493=:26901
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 2 Feb 2006, Stephen Clark wrote:

> Hello List,
Hello,

> Does iptables have the capability to list out the actual nat=20
> mappings/translations,
> not just the rules that are currently active -
Please use "conntrack -L" or "cat /proc/net/ip_conntrack" for older=20
kernels than 2.6.14.

Best regards,

 =09=09=09Krzysztof Ol=EAdzki

PS: This is a devel ml.
---187430788-2020069243-1138912493=:26901--
