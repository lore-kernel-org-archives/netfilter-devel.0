From: Ross Vandegrift <ross@kallisti.us>
Subject: Re: What to do with malformed l4proto packets?
Date: Sat, 7 Apr 2007 12:34:53 -0400
Message-ID: <20070407163452.GA8625@kallisti.us>
References: <4615742B.3040708@psc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: John Heffner <jheffner@psc.edu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <4615742B.3040708@psc.edu>
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

On Thu, Apr 05, 2007 at 06:11:55PM -0400, John Heffner wrote:
> So, the question is: is there any reason to ACCEPT TCP segments with 
> known bad checksums?

If you capture traffic from a Windows machine that has a NIC with
hardware checksum offload and load the pcap into wireshark, it almost
always seems to have invalid checksums.

I have no idea why, if they do this under other operating systems, or
if it's just this chipset (BCM NetXtreme II) or all checksum offload.
It doesn't seem to affect anything, as the packets are otherwise
always valid.


-- 
Ross Vandegrift
ross@kallisti.us

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
