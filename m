From: "David S. Miller" <davem@redhat.com>
Subject: Re: Extremely slow network with e1000 & ip_conntrack
Date: Thu, 4 Dec 2003 12:20:22 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031204122022.5250b104.davem@redhat.com>
References: <C6F5CF431189FA4CBAEC9E7DD5441E0102CBDD21@orsmsx402.jf.intel.com>
	<20031205045020.4C0E.MUKANSAI@emailplus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: scott.feldman@intel.com, laforge@netfilter.org,
        netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephen Lee <mukansai@emailplus.org>
In-Reply-To: <20031205045020.4C0E.MUKANSAI@emailplus.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 05 Dec 2003 04:53:33 +0900
Stephen Lee <mukansai@emailplus.org> wrote:

> I have a 32-bit PCI card with bcm5705 on it, does that support TSO? 
> I'll give it a try today.

Yep it does, but it is not enabled by default.  You have
to enable it explicitly using ethtool.
