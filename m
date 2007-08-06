From: Patrick McHardy <kaber@trash.net>
Subject: Re: Wrong MAC with vlans in LOG
Date: Mon, 06 Aug 2007 14:31:48 +0200
Message-ID: <46B714B4.3040802@trash.net>
References: <Pine.LNX.4.64.0708061331010.23493@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708061331010.23493@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> Hello,
> 
> Just discovered that -j LOG produces wrong MAC=(...) with non
> hardware-accelerated vlans:
> 
> IN=vlan6 OUT= MAC=00:0e:0c:a1:ba:ce:00:01:42:2f:3a:60:08:00
> SRC=38.102.233.175 DST=XXX.XXX.XXX.XXX LEN=225 TOS=0x00 PREC=0x00 TTL=46
> ID=0 DF PROTO=UDP SPT=4679 DPT=23020 LEN=205
> 
> Please notice that mac address is two bytes longer than it should be and
> the additional 08:00 is an ethertype value: 0x0800 - IPv4.
> 
> Any ideas?


That also happends for normal ethernet packets. We decided that its
not worth potentially breaking parsers to fix this, ipt_LOG is not
very well suited for anything but debugging anyway.
