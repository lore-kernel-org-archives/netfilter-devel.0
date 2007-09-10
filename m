From: Patrick McHardy <kaber@trash.net>
Subject: Re: u32 extension
Date: Mon, 10 Sep 2007 12:33:33 +0200
Message-ID: <46E51D7D.9000003@trash.net>
References: <46E50BE5.80401@trash.net>
	<Pine.LNX.4.64.0709101227020.11640@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0709101227020.11640@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> On Sep 10 2007 11:18, Patrick McHardy wrote:
> 
>>Hi Jan,
>>
>>I just noticed the u32 extension is missing from iptables.
>>Could you send me your latest version please.
>>
> 
> 
> 
> Adds u32 to iptables.


Applied, thanks Jan.

>  symlink extensions/libip6t_u32.man -> extensions/libipt_u32.man


I copied it and fixed a bunch of warnings on 64 bit:

extensions/libxt_u32.c: In function 'u32_parse':
extensions/libxt_u32.c:146: warning: format '%u' expects type 'unsigned
int', but argument 3 has type 'long int'
extensions/libxt_u32.c:160: warning: format '%u' expects type 'unsigned
int', but argument 3 has type 'long int'
extensions/libxt_u32.c:173: warning: format '%u' expects type 'unsigned
int', but argument 3 has type 'long int'
extensions/libxt_u32.c:178: warning: format '%u' expects type 'unsigned
int', but argument 3 has type 'long int'
extensions/libxt_u32.c:184: warning: format '%u' expects type 'unsigned
int', but argument 3 has type 'long int'
extensions/libxt_u32.c:193: warning: format '%u' expects type 'unsigned
int', but argument 3 has type 'long int'
extensions/libxt_u32.c:204: warning: format '%u' expects type 'unsigned
int', but argument 3 has type 'long int'
extensions/libxt_u32.c:207: warning: format '%u' expects type 'unsigned
int', but argument 3 has type 'long int'
extensions/libxt_u32.c:214: warning: format '%u' expects type 'unsigned
int', but argument 3 has type 'long int'
extensions/libxt_u32.c:224: warning: format '%u' expects type 'unsigned
int', but argument 3 has type 'long int'
extensions/libxt_u32.c:244: warning: format '%u' expects type 'unsigned
int', but argument 3 has type 'long int'
