From: jamal <hadi@cyberus.ca>
Subject: Re: tc filtering vs iptables
Date: 27 Aug 2004 14:45:24 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1093632324.14188.2.camel@jzny.localdomain>
References: <1093614389.1068.20.camel@jzny.localdomain>
	<Pine.LNX.4.61.0408271751360.32691@filer.marasystems.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0408271751360.32691@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2004-08-27 at 11:54, Henrik Nordstrom wrote:
> On Fri, 27 Aug 2004, jamal wrote:
> 
> > Let me know how to create proper chains for a range of hosts
> > {1,2,8, 64,256,4096,8192,16384,32768,64K}
> 
> For very many unique hosts in iptables it is better to use an ippool for 
> matching the source IP, or to look into using hipac.

Both of them seem to be a hassle for what i need (and given the time i
have). hipac seems to be a 2.4.x thing and pool requires me to recompile
a few things (while docs look scarce). I dont have much time to get this
done by - when i have more time in the future i could do it.

Any recommendation of how i should arrange the chains?

cheers,
jamal
