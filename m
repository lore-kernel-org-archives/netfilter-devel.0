From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] iptables-xml
Date: Tue, 17 Jul 2007 17:54:20 +0200
Message-ID: <469CE62C.30305@trash.net>
References: <469B4410.300@ufomechanic.net> <469CDBF7.6070202@trash.net>
	<469CE066.2020501@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <469CE066.2020501@ufomechanic.net>
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

Amin Azez wrote:
> * Patrick McHardy wrote, On 17/07/07 16:10:
> 
>>I assume these changes are compatible with previous versions?
>>  
> 
> Yes, although (3) indicates a change in behaviour,
> a. nothing here will prevent previously generated xml from forming the
> same iptables rules.
> b. although slightly different xml may be generated (due to different
> target combining with the -c switch), the new or old xslt will still
> generate the same iptables rules from the new xml.


OK, I trust you know what you're doing (when it comes to XML,
I certainly don't :))

Applied.
