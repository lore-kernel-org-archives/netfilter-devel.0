From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: mask for interface
Date: Sat, 27 Mar 2004 01:56:02 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403270155130.11373-100000@filer.marasystems.com>
References: <406440F3.8010203@aiqa.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ozgur AKAN <akan@aiqa.com>
In-Reply-To: <406440F3.8010203@aiqa.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 26 Mar 2004, Ozgur AKAN wrote:

> Hi,
> 
> In the manual of iptables there is nothing about the mask value of an 
> interface. + sign at the end of a few characters of an interface means 
> any interface which begins with this name will match.
> 
> Again what I wonder is the why iniface_mask value is used???

Again, it is used for the + wildcard.

In theory it could be used for other things as well, but only the + 
wildcard is implemented in the iptables application.

Regards
Henrik
