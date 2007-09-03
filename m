From: "Michael Ransburg" <michael.ransburg@gmail.com>
Subject: Measure CPU load of a filter application based on libipq
Date: Mon, 3 Sep 2007 10:15:01 +0200
Message-ID: <22b256140709030115o63fb1a09p9bd623ed317988f7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Netfilter Developer Mailing List" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Hi all,

I'm on a Fedora Core 6 i386 machine. I have implemented a packet
filter based on libipq which works great. It basically looks into the
IP and UDP header of each packet and decides on its fate based on
this.

I'm now trying to get some simple measurements of the performance of
this filter. Basically I use "ps hu -p $pid" to periodically (every
0.1 seconds) output the CPU load and memory consumption (where $pid is
the process ID of the filter) to a file.

This works fine for memory consumption, however for CPU load I always
get 0. The filter is processing about 100 UDP/IP packets / second. I'm
aware that the CPU load of ps corresponds to the CPU time divided by
the runtime of the process, so I made sure to restart the filter
before starting the measurements.

When I artificially introduce extra CPU load to my filter (by calling
some functions of a library which I know are CPU intensive), then the
CPU load goes up, as expected.

Can anyone shed some light on this? Is the CPU load really that low
(very close to 0) for the above filter? Or is ps unable to measure
some of the CPU load of my filter because it is "kernel" CPU load (I'm
obviously guessing here).

Any hints / inputs on what is going wrong and on how I can get an idea
of the CPU load of my libipq filter application would be great.

Many thanks,
Michael

-- 
icq: 71772353 | skype: daneel1409 | msn: mike@unfolded.com
