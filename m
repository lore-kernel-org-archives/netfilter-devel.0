From: Patrick Schaaf <bof@bof.de>
Subject: Re: Can IP MF and DF flags be set simulataneously
Date: Sat, 21 Sep 2002 10:59:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020921085912.GA282@oknodo.bof.de>
References: <20020920235513.30242.qmail@web11901.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Vijay Gullapalli <vjgullapalli@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20020920235513.30242.qmail@web11901.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Vijay,

please take your question to a more general forum related to IP
networking, this mailing list is too specific in scope.

If you find that something is to be illegal here (which I doubt),
and iptables/netfilter does a wrong thing (that the rest of the
IP stack does right), then please come back.

Sorry if I seem harsh, but we can't cover all quirks of the TCP/IP
protocol suite here. This is no educational facility.

Finally, one hint: fragments of packets can and will be further
fragmented, when you have more than two MTUs in the path of
the packet. That's why I doubt that your suspicion is correct.

best regards
  Patrick

On Fri, Sep 20, 2002 at 04:55:13PM -0700, Vijay Gullapalli wrote:
> Hi,
> 
> I came across this list when searching for TCP SYN
> Proxy links on google. And I have a very basic
> question about IP fragment flags DF (don't fragment)
> and MF (more fragment) usage. If this is not the right
> forum, please excuse me.
> 
> While monitoring NFS/UDP traffic between two Linux
> machines, I noticed that when Path MTU is turned on,
> the IP header has both the DF and MF bits set at the
> time. Is it legal to have have both flags set at the
> same time? Isn't it enough to have just the DF bit set
> to do Path MTU discovery?
> 
> Having both on at the same time goes against these
> flags usage described in Internet Protocol RFC 791.
> Are there any other RFCs which supercede RFC 791 and
> describe how/why these flags should be allowed to be
> set at the same time.
> 
> Thank you,
> Vijay Gullapalli
> 
> __________________________________________________
> Do you Yahoo!?
> New DSL Internet Access from SBC & Yahoo!
> http://sbc.yahoo.com
