From: Max Kellermann <max@duempel.org>
Subject: Re: [PATCH nfsim] RFC: quote control and 8bit characters in the
	data portion
Date: Sat, 12 Feb 2005 12:07:11 +0100
Message-ID: <20050212110711.GA30182@roonstrasse.net>
References: <20050211225628.GA27755@roonstrasse.net>
	<20050212003156.GA16948@zion.homelinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050212003156.GA16948@zion.homelinux.com>
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

On 2005/02/12 01:31, Sven Schuster <schuster.sven@gmx.de> wrote:
> one thing I could think about and what would be quite handy IMHO
> would be to give packet input to nfsim from tcpdump files. So one
> could make some captures of packets on the wire and then feed them
> to nfsim for testing. Unfortunately, I didn't have time to think a
> little bit more about this...

Your idea tries to solve another problem, not mine. It tries to make
it easier to inject binary packages, but my problem is writing the
expectation string, which requires me to write the test case (=text
file) with a hex editor.

I believe it is good that test cases are self contained, and no
external dump file has to be loaded, although that may make a useful
additional feature.

Max
