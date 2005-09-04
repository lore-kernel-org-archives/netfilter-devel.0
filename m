From: Phil Oester <kernel@linuxace.com>
Subject: Re: [RFC NETFILTER 2/2]: Add NetBIOS name service helper
Date: Sun, 4 Sep 2005 08:40:16 -0700
Message-ID: <20050904154016.GA25949@linuxace.com>
References: <431ADF56.2050000@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <431ADF56.2050000@trash.net>
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

On Sun, Sep 04, 2005 at 01:49:42PM +0200, Patrick McHardy wrote:
> +	  NetBIOS name service requests are sent as broadcast message from an
  +	  NetBIOS name service requests are sent as broadcast messages from an

> +	  unpriviledged port and responded to with unicast messages to the
  +	  unprivileged port and responded to with unicast messages to the

> + *      requests by issueing permanent expectations (valid until
  + *      requests by issuing permanent expectations (valid until

> + *      timeing out) matching all reply connections from the
  + *      timing out) matching all reply connections from the


Phil
