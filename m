From: Kenneth Porter <shiva@sewingwitch.com>
Subject: Re: Discrete packaging of experimental modules
Date: Sat, 18 Sep 2004 20:26:39 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <A84BC229C200AB59DB0F0B0D@[10.0.0.4]>
References: <0D0567C424F9F491BBAACF88@[10.169.6.246]>
	<Pine.LNX.4.61.0409181842420.17139@filer.marasystems.com>
	<BB3C25FF8798E8E693A13041@[10.0.0.4]>
	<20040918223035.GA31093@zion.homelinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20040918223035.GA31093@zion.homelinux.com>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

--On Sunday, September 19, 2004 12:30 AM +0200 Sven Schuster 
<schuster.sven@gmx.de> wrote:

> thats's actually the way it works by default. The userspace extensions for
> the iptables command are compiled and linked as shared libraries and
> loaded at runtime, the default location is /usr/local/lib/iptables.

Even better. Sounds like I should be able to build an RPM for TARPIT (and 
other extensions I decide to play with) using the pom and iptables tarballs 
as input.
