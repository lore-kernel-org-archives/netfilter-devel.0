From: Amin Azez <azez@ufomechanic.net>
Subject: Re: Mangling IP Options fields
Date: Fri, 20 May 2005 12:17:44 +0100
Message-ID: <428DC758.7060503@ufomechanic.net>
References: <42889454.6040300@hoole.biz> <4288E9D7.10306@outerspace.dyndns.org>
	<428C8D66.3030908@hoole.biz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Quinton Hoole <quinton@hoole.biz>
In-Reply-To: <428C8D66.3030908@hoole.biz>
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

Apologies if these comments (below) seem obvious:

Quinton Hoole wrote:
> Warning - no help text file could be found in either
> /usr/src/linux/net/ipv4/netfilter/Config.help
> or /usr/src/linux/Documentation/Configure.help
> fgrep: /usr/src/linux/net/ipv4/netfilter/Config.in: No such file or 
> directory
...
> I installed the kernel source RPM according to the instructions in the 
> FC3  (http://fedora.redhat.com/docs/release-notes/fc3/x86/), which 
> places  the kernel source in
> 
> /usr/src/redhat/BUILD/kernel-2.6.11/linux-2.6.11
> 
> For convenience I  created a symbolic link from /usr/src/linux to the 
> above.

So, do:
ls -l /usr/src/linux/net/ipv4/netfilter
and see what you get, if it doesn't work then you may need to adjust 
your symbolic link to point to 
/usr/src/redhat/BUILD/kernel-2.6.11/linux-2.6.11/somewhereelse

I presume there is a net folder somewhere under 
/usr/src/redhat/BUILD/kernel-2.6.11/linux-2.6.11?

It is the folder that includes this net folder that needs to be 
symlinked to /usr/src/linux.

Sam
