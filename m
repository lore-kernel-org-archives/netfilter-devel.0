From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Updating a modular ip_queue
Date: Tue, 2 Mar 2004 00:29:10 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403020027500.15826-100000@filer.marasystems.com>
References: <20040301210046.74474.qmail@web13903.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott MacKay <scottmackay@yahoo.com>
In-Reply-To: <20040301210046.74474.qmail@web13903.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 1 Mar 2004, Scott MacKay wrote:

> I plan to build ip_queue in module format and compile
> the libraries by hand (so the libs get the full
> ip_packet_msg definition).  On doing this, do I really
> need to anything to the distributed kernel other than
> copy the ip_queue.o object file into the /lib area?  

Not that I know of. The structure is as you mention internal to ip_queue 
and not used by any other parts of the kernel.

Regards
Henrik
