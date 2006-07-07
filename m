From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] new match (equal)
Date: Fri, 07 Jul 2006 06:05:25 +0200
Message-ID: <44ADDD85.6030301@trash.net>
References: <44ACD830.30108@anduras.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Anders <anders@anduras.de>
In-Reply-To: <44ACD830.30108@anduras.de>
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

Sven Anders wrote:
> Hello!
> 
> This is a new match to check for equal IPs and/or devices.
> Maybe it's of any use to somebody else...
> 
> Please add it patch-o-matic-ng.

I'm not sure this is something we want to take care of ourselves,
but feel free to send me a URL to an external repository to include.

> Comments welcome!

This mainly shows too me that we really want something like
the meta ematch (but also for non-meta data), which would
also obsolete all matches that basically only compare a
single attribute of a packet (or do range matches or
something like that).
