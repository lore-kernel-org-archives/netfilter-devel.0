From: Rich Wellner <rkw@objenv.com>
Subject: Re: trouble with expect_related
Date: Tue, 07 Jan 2003 09:59:02 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <t2mk7hhx86x.fsf@rw2-laptop.wellner.org>
References: <t2mk7hlwz5c.fsf@rw2-laptop.wellner.org>
	<1041651291.1637.41.camel@exile> <t2mwulie0cu.fsf@rw2-laptop.wellner.org>
	<1041933003.502.23.camel@xbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Filip Sneppe <filip.sneppe@cronos.be>
In-Reply-To: <1041933003.502.23.camel@xbox> (Filip Sneppe's message of "07
 Jan 2003 10:50:02 +0100")
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Filip Sneppe <filip.sneppe@cronos.be> writes:

> On Mon, 2003-01-06 at 16:58, Rich Wellner wrote:
>> "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be> writes:
>>
>> Can anyone else comment?
>> 
> Do you see the expected connection in /proc/net/ip_conntrack? It should
> be preceded by "EXPECTING:" if it hasn't seen any traffic yet.

Ok, this is very helpful.  I didn't know about that vfile.  There is the line
I expect there.

EXPECTING: proto=6 src=131.225.80.34 dst=207.252.250.2 sport=0 dport=41209

I don't know where to look to find out what proto 6 is, but the rest *seems*
ok.

The src, 131.225.80.34 is the machine I expect to be calling me back.  The
sport of 0 should be ok because I don't have that byte masked in my call to
expect_related the dport is correct.

I wasn't sure if the dst should be the NAT node or the private net node, so
I've tried it both ways:

EXPECTING: proto=6 src=131.225.80.34 dst=192.168.1.2 sport=0 dport=41330

And neither forwarded the connection.  Judging by the FTP example the dst
should be the private node, right?

And I reconfirmed using tcpdump that the incoming connection is still being
attempted and is on the correct port.

rw2
