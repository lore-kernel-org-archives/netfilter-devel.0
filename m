From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: RFC: Partial IP4 syntax
Date: Wed, 29 Sep 2004 18:54:50 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409291837430.15266@filer.marasystems.com>
References: <415A12AE.1060901@parknet.dk>
	<Pine.LNX.4.61.0409291042240.11661@filer.marasystems.com>
	<415AE4CE.3030305@parknet.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Ben Efros <ben@xgendev.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Simon Lodal <simonl@parknet.dk>
In-Reply-To: <415AE4CE.3030305@parknet.dk>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 29 Sep 2004, Simon Lodal wrote:

> When people talk about the 10.44 network, I assume they append .0.0, not 
> insert them in the middle. My proposal does that with a double dot, eg. 
> 10..44 = 10.0.0.44.

There is a well established meaning in the computing industry of 10.44 to 
mean 10.0.0.44, not 10.44.0.0.

There is also a well established meaning in the routing business of 
10.44/24 to mean 10.44.0.0/24, but then only in CIDR notation with a mask 
size (not netmask), and certainly not without the mask size.

There is no one using double dots that I know of.

Guessing the netmask size is generally bad and should be avoided imho. 
Lots of problems have been caused by computers guessing netmasks based on 
zeroes..

>> 10.59470 is the same as 10.0.232.78
>> 
>> 2888886350 is the same as 172.48.232.78
> I understand if that is being deprecated.
>
> They could at least have used hex!

Many allows hex notation using 0xXX syntax per element in the IP address..

0x54.0x63.0xFE.0xEE
0x5463FEEE
0x54.0x63FEEE
84.6553326
84.99.254.238
84.99.13094

is all the same IP address. You can try it with ping if in doubt.

> What I also want is a way to only specify the least significant bits. If I do 
> not care about the first octet (10), the above would just become ".1".

Which with the already established notation is simply 1/0.255.255.255 
which matches *.0.0.1

Regards
Henrik
