From: Scott MacKay <scottmackay@yahoo.com>
Subject: Re: Packet checksum
Date: Wed, 4 Feb 2004 05:54:29 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040204135429.46779.qmail@web13904.mail.yahoo.com>
References: <4020F2C5.6030805@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>, netfilter-devel@lists.netfilter.org
In-Reply-To: <4020F2C5.6030805@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

TY!  

-Scott

--- Pablo Neira <pablo@eurodev.net> wrote:
> Hi Scott,
> 
> Scott MacKay wrote:
> 
> >When, in the great scheme of things, does packet
> >checksum (and potential packet drop for bad
> checksums)
> >occur?  Is there a particular point in the
> netfilter
> >process or does it occur before/after the chains?
> >  
> >
> AFAIK, the ip header checksum is done before the
> packet gets the 
> NF_PREROUTING hook,
> so the packet will be drop before it hits netfilter.
> 
> Have a look at the ip_rcv(...) function 
>
(http://lxr.linux.no/source/net/ipv4/ip_input.c#L418)
> 
> could anyone confirm this?
> 
> cheers,
> Pablo
> 


__________________________________
Do you Yahoo!?
Yahoo! SiteBuilder - Free web site building tool. Try it!
http://webhosting.yahoo.com/ps/sb/
