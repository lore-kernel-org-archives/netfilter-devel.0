From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] C99 patches for net/bridge/netfilter
Date: Mon, 03 Mar 2003 01:26:11 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030303.012611.129838536.davem@redhat.com>
References: <20030227172525.GA21084@debian>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org, netfilter-devel@lists.netfilter.org,
        linux-net@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: ahaas@airmail.net
In-Reply-To: <20030227172525.GA21084@debian>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

   From: Art Haas <ahaas@airmail.net>
   Date: Thu, 27 Feb 2003 11:25:25 -0600

   Here are three patches for converting files in net/bridget/netfilter to
   use C99 initializers. The patches at first were just going to be adding
   an '=' to array initializers, but then I decided to add named
   initializers to the structures as I thought it would make them easier to
   read.

Thanks Art, patch applied.
