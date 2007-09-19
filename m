From: Patrick McHardy <kaber@trash.net>
Subject: Re: u32 extension
Date: Wed, 19 Sep 2007 14:52:05 +0200
Message-ID: <46F11B75.1040402@trash.net>
References: <46E50BE5.80401@trash.net>	<Pine.LNX.4.64.0709101227020.11640@fbirervta.pbzchgretzou.qr>	<46E51D7D.9000003@trash.net>	<Pine.LNX.4.64.0709101238110.11640@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0709151723500.23681@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0709151723500.23681@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> warning: format '%ld' expects type 'long int', but argument 3 has type 'int'.
> 
> Oh well, oh well. Patch below.
> ===
> 
> 
> With %u alone, you would get "but arg-start is long" warnings on x64.
> With %lu, you would get "but arg-start is int" on x86.
> Fix it up by explicitly deciding for one (%u and cast to unsigned int)
> and using that.


Applied, thanks Jan.
