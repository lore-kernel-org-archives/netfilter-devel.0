From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] ROUTE target with ARP lookups
Date: 26 Mar 2003 00:35:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1048635304.14737.81.camel@tux.rsn.bth.se>
References: <1048519994.27352.149.camel@descartes.info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Cedric de Launois <delaunois@info.ucl.ac.be>
In-Reply-To: <1048519994.27352.149.camel@descartes.info.ucl.ac.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2003-03-24 at 16:33, Cedric de Launois wrote:
> Here is a patch for the --oif option of the ROUTE target.
> When sending to a destination through an interface, the target
> now performs ARP cache lookup & ARP request (excepted if the
> device is a tunnel). This should now enable "Transparent broadband
> network connectivity (IP PnP)" as John said.
> 
> The patch is against the current CVS tree.

I don't really like the check for ARP-able devices...
There are a lot more non-arpable devices than the ones you test for.
And your code looks ethernet specific so why not test for ARPHRD_ETHER
instead?

I havn't followed the discussion on the use of this, but it's probably
useful :)

If you fix the dev->type issue or convince me it should look like it
does I'll be glad to apply the patch.

-- 
/Martin
