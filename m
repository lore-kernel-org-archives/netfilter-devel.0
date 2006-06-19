From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: [PATCH] entry_data
Date: Tue, 20 Jun 2006 00:35:06 +0200
Message-ID: <200606200035.07197.max@nucleus.it>
References: <200606050029.08602.max@nucleus.it> <448FD0F6.3010506@anduras.de>
	<4496E037.2000706@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4496E037.2000706@trash.net>
Content-Disposition: inline
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

On Monday 19 June 2006 7:34 pm, Patrick McHardy wrote:

> Yes, userspace ignores these fields. I still haven't really made up my
> mind about this patch yet. I don't like the void ** approach very much,

I understand your concerns, but it's either that or feeding it its own struct 
xt_entry_match *. This would be awfully circular, while the practice of 
passing someting * to functions is widespread. This only happens to be 
applied to a void *.

If anyone has a better way s?he's more than welcome.

> but I didn't got around to thinking about something better yet. Please
> stay patient with me :)

I'll be patient. :)

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
