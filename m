From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: ongoing textsearch/string match - 3 patches
Date: Thu, 26 Jan 2006 14:35:16 +0100
Message-ID: <43D8D014.8030108@eurodev.net>
References: <18730dc50512220611nfea98e2l88da4f25c97f341d@mail.gmail.com>	
	<43AB2739.6080608@eurodev.net>	
	<18730dc50512250828i2f214c8di49c348f03c84593f@mail.gmail.com>	
	<43AF689F.2070106@eurodev.net>
	<18730dc50601260351s7dab9451x420f3eb88bc90162@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: amir73il@gmail.com
In-Reply-To: <18730dc50601260351s7dab9451x420f3eb88bc90162@mail.gmail.com>
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

Hi Amir,

amir73il@gmail.com wrote:
>>Could you comment any realistic scenario?
>>
> the usefulness of matching a pattern between packets is for network virus scan.
> it took me some time to finalize my kclamav module, but here it is:
> http://sourceforge.net/projects/kclamav/
> 
> I patched the string match netfilter because it was the closest filter
> to what I needed, but as I said, there is still work to be done to
> make this a useful virus scan filter.
> perhaps a more generic "content filter" is more appropriate here.
> 
> I hope you will find this contribution useful and help me get my
> patches into the kernel.

Sorry for not replying. I haven't forgotten this. I think I can improve
that patch. I'll give it a spin this weekend and I'll get back to you.

-- 
Pablo
