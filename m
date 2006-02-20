From: Patrick McHardy <kaber@trash.net>
Subject: Re: SIP helper review
Date: Mon, 20 Feb 2006 18:34:59 +0100
Message-ID: <43F9FDC3.50102@trash.net>
References: <200602192312.05240.lists@ohlmeier.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Christian Hentschel <chentschel@arnet.com.ar>,
	Harald Welte <laforge@gnumonks.org>, Harry Behrens <harry@behrens.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Nils Ohlmeier <lists@ohlmeier.org>
In-Reply-To: <200602192312.05240.lists@ohlmeier.org>
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

Nils Ohlmeier wrote:
> Hello,
> 
> I'm not a kernel programer but with several years experience in the SIP 
> business I could call myself a SIP expert I guess. Therefor I was asked by a 
> friend to take a look at the current SIP netfiler module.
> 
> So I made a code review of the code from this link:
> http://svn.netfilter.org/netfilter/trunk/patch-o-matic-ng/patchlets/sip-conntrack-nat/linux-2.6.13/

Thanks for your help.

> From looking at the code I think I found the following two issues which might 
> be worth fixing:
> 
> 1) As far as I got it the skp_epaddr_len function in ip_conntrack_sip.c 
> expects to find a username in the SIP URI in the Contact header. As usernames 
> are generally optional in SIP URIs there are several User Agents (UA), 
> especially the cheaper hardware UA's which support only one SIP account, 
> which do not put a username into their Contact's. Thus I would propose that 
> the searching for the username in the Contact header should be optional as 
> well.

I think this is what made the helper fail with my crappy chinese SIP
ATA. Without the username, is there still an '@'-character (in which
case it should work as it is) or does the string start directly with
the address?

> 2) As far as I got it the epaddr_len function looks for 'UDP' in Via headers. 
> Is it by intention that the IP address replacement would only work for the 
> UDP transport but not for TCP? Allthough TCP is not very widely used yet I 
> think it should be easy to do the replacement for TCP as well, or?

It should be easy to change. Is TCP used for SIP itself? In that case
it would also have to register for TCP in addition to UDP.
