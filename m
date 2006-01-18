From: Patrick McHardy <kaber@trash.net>
Subject: Re: Linux 2.6.16-rc1
Date: Wed, 18 Jan 2006 02:41:46 +0100
Message-ID: <43CD9CDA.6030509@trash.net>
References: <Pine.LNX.4.64.0601170001530.13339@g5.osdl.org>
	<200601172106.k0HL6LMW008241@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@osdl.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Valdis.Kletnieks@vt.edu
In-Reply-To: <200601172106.k0HL6LMW008241@turing-police.cc.vt.edu>
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

Valdis.Kletnieks@vt.edu wrote:
> On Tue, 17 Jan 2006 00:19:56 PST, Linus Torvalds said:
> 
> 
>>And largish networking updates: there's a "common netfilter" setup now, 
>>which you'll notice when you do "make config" or equivalent, since a lot 
>>of the netfilter rules now work on ipv4 and/or ipv6 rather than having 
>>separate (and duplicate) versions for each.
> 
> 
> Hooray! Finally. ;)
> 
> Does this require modprobing of the modules by hand, or is there a version
> of iptables in the pipe that knows how to do this?  I checked the CVS snapshot
> directory on ftp.netfilter.org last night, and the latest one there didn't
> know about this yet.

The modules have aliases for their old names, so they should get
autoloaded. The matches and targets that didn't exist for IPv6
before need new extensions in userspace before they can be used
though.
