From: "David S. Miller" <davem@redhat.com>
Subject: Re: Extremely slow network with e1000 & ip_conntrack
Date: Thu, 4 Dec 2003 10:24:20 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031204102420.2aa43b43.davem@redhat.com>
References: <C6F5CF431189FA4CBAEC9E7DD5441E0102CBDD1F@orsmsx402.jf.intel.com>
	<20031204213030.2B75.MUKANSAI@emailplus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: scott.feldman@intel.com, laforge@netfilter.org,
        netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephen Lee <mukansai@emailplus.org>, torvalds@osdl.org
In-Reply-To: <20031204213030.2B75.MUKANSAI@emailplus.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 04 Dec 2003 21:36:09 +0900
Stephen Lee <mukansai@emailplus.org> wrote:

> "Feldman, Scott" <scott.feldman@intel.com> wrote:
> > 
> > Try turning off TSO by disabling this code or by using "ethtool -K tso
> > off" (need version 1.8).
> 
> Yes, turning off TSO with ethtool fixed it (tested on 2.6.0-test11).  At
> least we have a workaround now.
> 
> Thanks Scott, Harald and Dave.
> 
> Is it not supported by the hardware?  Seems TSO could improve
> performance a bit since the 1000/MT Desktop is starved for PCI bandwidth
> at 32-bit/33MHz.

This workaround explains everything.  The TSO packets have to be
"un-TSO'd" in order for netfilter to look at the packet and parse
the contents.  This means copying all the data around, allocating
several networking buffers, etc.
