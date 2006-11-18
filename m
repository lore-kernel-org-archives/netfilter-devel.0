From: "Laurence J. Lane" <ljlane@debian.org>
Subject: Re: iptables 1.3.6 not using /etc/networks
Date: Sat, 18 Nov 2006 17:12:39 -0500
Message-ID: <cd6061db0611181412s4241901cp28dbcaeed678f79c@mail.gmail.com>
References: <cd6061db0611111725q2822d96cg2272b44dc3e85d0b@mail.gmail.com>
	<cd6061db0611111835u7d6ea889g56822e458e3e12f2@mail.gmail.com>
	<20061112173312.GA2593@linuxace.com>
	<cd6061db0611181409i27ef1f68l49517bf56c45128b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Phil Oester" <kernel@linuxace.com>
In-Reply-To: <cd6061db0611181409i27ef1f68l49517bf56c45128b@mail.gmail.com>
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

On 11/18/06, Laurence J. Lane <ljlane@debian.org> wrote:

>   # echo "foonet0 3.2.1.0" > /etc/networks
>   # for i in 8 16 24 32; do iptables -v -A INPUT -s foonet0/$i -j ACCEPT; done

I pasted the wrong line there. The list is clearly reversed.
