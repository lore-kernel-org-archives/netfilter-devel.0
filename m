From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: Changing the content of tcp timeouts in
	ip_conntrack_proto_tcp.c
Date: Wed, 14 Jan 2004 13:50:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1074084643.15865.6.camel@nienna.balabit>
References: <Pine.LNX.4.44.0401141203530.29640-100000@filer.marasystems.com>
	 <40053873.6000806@netlab.hut.fi>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: emmanuel@netlab.hut.fi
In-Reply-To: <40053873.6000806@netlab.hut.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

On Wed, 2004-01-14 at 13:39, Emmanuel Guiton wrote:
> >Looks like you have not exported this function from ip_conntrack. To use a 
> >function from another module than it is defined in the function must first 
> >be exported from the module where it is defined.
> 
> Well, I think I did. I defined my function in the 
> ip_conntrack_proto_tcp.c and I exported its prototype in ip_conntrack.h.
> Then I call it in my target module which also uses ip_conntrack.h.

  You have to explicitly export it using the EXPORT_SYMBOL() (or
EXPORT_SYMBOL_GPL) macro in ip_conntrack_standalone.c. It has a lot of
other exported symbols, just add another one.

-- 
 Regards,
   Krisztian KOVACS
