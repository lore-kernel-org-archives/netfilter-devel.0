From: "Laurence J. Lane" <ljlane@debian.org>
Subject: Re: iptables 1.3.6 not using /etc/networks
Date: Sat, 11 Nov 2006 21:35:08 -0500
Message-ID: <cd6061db0611111835u7d6ea889g56822e458e3e12f2@mail.gmail.com>
References: <cd6061db0611111725q2822d96cg2272b44dc3e85d0b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <cd6061db0611111725q2822d96cg2272b44dc3e85d0b@mail.gmail.com>
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

On 11/11/06, Laurence J. Lane <ljlane@debian.org> wrote:

>   # strace -s 255 -o /tmp/bar iptables -v -A INPUT -s foonet/8 -j
> ACCEPT #1.3.6 [2]
>   iptables v1.3.6: host/network `foonet.0.0.0' not found
>   Try `iptables -h' or 'iptables --help' for more information.

This looks like something with the pad_cidr() call in
parse_hostnetworkmask(). ltrace shows the code calling
getnetbyname("foonet.0.0.0")  instead of getentbyname("foonet").
