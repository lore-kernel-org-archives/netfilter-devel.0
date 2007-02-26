From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Is libiptc still the preferred library for manipulating tables?
Date: Mon, 26 Feb 2007 13:23:02 +0100
Message-ID: <45E2D126.7010003@netfilter.org>
References: <57f837150702251105y7d70c345n233a75fc2f328592@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Warren Kenny <warren.kenny@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <57f837150702251105y7d70c345n233a75fc2f328592@mail.gmail.com>
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

Warren Kenny wrote:
> This subject seems a bit hazy to me at the moment. Basically I'm
> writing a network intrusion detection and prevention system for Linux
> and I'd like to be able to use Netfilter to block packets coming from
> nodes which have been identified as malicious. I'd prefer to avoid the
> use of libnetfilter_queue since I'm already using libpcap for packet
> analysis and it has some extras that I rely on. Basically I want to
> add new tables and rules from within my application in order to filter
> out malicious traffic.
> 
> There seem to be a lot of different guides on how to do this, most of
> which are obsolete, including the guide on libiptc. I need to know the
> latest and best way to manipulate iptables rules.

Unfortunately, libiptc is not a supported as a standalone library, it is 
just a directory inside iptables. The only interface available, at the 
moment, is iptables, the command line tool. You can blame us for not 
providing an appropiate library interface yet.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
