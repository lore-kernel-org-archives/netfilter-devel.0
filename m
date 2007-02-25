From: "Warren Kenny" <warren.kenny@gmail.com>
Subject: Is libiptc still the preferred library for manipulating tables?
Date: Sun, 25 Feb 2007 19:05:38 +0000
Message-ID: <57f837150702251105y7d70c345n233a75fc2f328592@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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

This subject seems a bit hazy to me at the moment. Basically I'm
writing a network intrusion detection and prevention system for Linux
and I'd like to be able to use Netfilter to block packets coming from
nodes which have been identified as malicious. I'd prefer to avoid the
use of libnetfilter_queue since I'm already using libpcap for packet
analysis and it has some extras that I rely on. Basically I want to
add new tables and rules from within my application in order to filter
out malicious traffic.

There seem to be a lot of different guides on how to do this, most of
which are obsolete, including the guide on libiptc. I need to know the
latest and best way to manipulate iptables rules.

Thanks,
WK
