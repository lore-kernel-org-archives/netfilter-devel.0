From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: childlevel's pom comment
Date: Thu, 4 Mar 2004 23:47:09 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403042341580.30943-100000@filer.marasystems.com>
References: <Pine.LNX.4.60.0403041500280.10634@dsl093-017-216.msp1.dsl.speakeasy.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Matthew Strait <quadong@users.sourceforge.net>
In-Reply-To: <Pine.LNX.4.60.0403041500280.10634@dsl093-017-216.msp1.dsl.speakeasy.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 4 Mar 2004, Matthew Strait wrote:

> It seems like I'd have to make significantly more invasive changes than
> are really called for to get it to accept an empty string.  What do you
> think?

Not really invasive, but yes some changes is needed in the kernel module 
to relax the input verification. See the check() function.

Regards
Henrik
