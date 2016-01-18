From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -stable,4.x.y] netfilter: nf_nat_redirect: add missing
 NULL pointer check
Date: Mon, 18 Jan 2016 20:48:02 +0100
Message-ID: <20160118194802.GB2067@salvia>
References: <1446813886-5632-1-git-send-email-pablo@netfilter.org>
 <20151106170858.GB24185@kroah.com>
 <20151106172610.GA1357@salvia>
 <569D3C91.7040409@amazon.com>
 <20160118194718.GA2067@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg KH <gregkh@linuxfoundation.org>,
	netfilter-devel@vger.kernel.org, stable@vger.kernel.org
To: Munehisa Kamata <kamatam@amazon.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160118194718.GA2067@salvia>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jan 18, 2016 at 08:47:18PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Jan 18, 2016 at 11:27:13AM -0800, Munehisa Kamata wrote:
> > Hi Greg,
> > 
> > This commit is already in Linus's tree. Could you please pick this up for 4.1.y?
> 
> I submitted this twice... Last time I made it was this one:
> 
> http://patchwork.ozlabs.org/patch/544964/
> 
> Previous was rejected because it was not in Linus tree:
> 
> http://patchwork.ozlabs.org/patch/540946/
> 
> But the last attempt got no feedback...

BTW, you can find all my -stable submissions here:

http://patchwork.ozlabs.org/project/netfilter-devel/list/?state=*&q=stable-
