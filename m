From: Max Kellermann <max@duempel.org>
Subject: Re: SIP/RTP support coming?
Date: Sat, 12 Feb 2005 13:08:47 +0100
Message-ID: <20050212120847.GA30461@roonstrasse.net>
References: <5caa9b8705021203527b3891d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <5caa9b8705021203527b3891d@mail.gmail.com>
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

On 2005/02/12 12:52, Steve Davies <davies147@gmail.com> wrote:
> Are there plans to integrate this officially? Should I take time to
> (try to) update the patch to the 2.6.x kernel? Am I missing
> something?

I believe nobody is working on that yet; I planned to look at the code
when I'm done with the H.323 module, but that will take some time.

A lot people would be thankful if you hacked the source, and ported
that to Linux 2.6.11-rc3 (the API has changed very much since 2.6.10;
don't use the old API).

You should start with providing a patch-o-matic module (see netfilter
home page) of the original code, and then send patches with your
changes.

Max
