From: Stephen Lee <mukansai@emailplus.org>
Subject: Re: Extremely slow network with e1000 & ip_conntrack
Date: Fri, 05 Dec 2003 04:53:33 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031205045020.4C0E.MUKANSAI@emailplus.org>
References: <C6F5CF431189FA4CBAEC9E7DD5441E0102CBDD21@orsmsx402.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Cc: "Harald Welte" <laforge@netfilter.org>,
   <netfilter-devel@lists.netfilter.org>, <linux-kernel@vger.kernel.org>,
   "David S. Miller" <davem@redhat.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Feldman, Scott" <scott.feldman@intel.com>
In-Reply-To: <C6F5CF431189FA4CBAEC9E7DD5441E0102CBDD21@orsmsx402.jf.intel.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

"Feldman, Scott" <scott.feldman@intel.com> wrote:
> 
> TSO is support on 82540.  Turning off TSO is a workaround, but what's
> behind the dependency of TSO and ip_conntrack?  You indicated in an
> earlier note that having the ip_conntrack module loaded was a factor.
> Do you have a nic to try with tg3?  I believe tg3 has TSO enabled as
> well (in 2.6.0-test11).

I have a 32-bit PCI card with bcm5705 on it, does that support TSO? 
I'll give it a try today.

Stephen
