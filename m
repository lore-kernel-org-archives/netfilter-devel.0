From: Andrew Beverley <andy@andybev.com>
Subject: How does iptables 'make' pick which modules to compile?
Date: Wed, 07 Feb 2007 11:54:59 +0000
Message-ID: <20070207115459.l45qqpib288cwg0g@www.simplelists.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1
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

Hi,

I'm trying to get iptables 1.3.7 to compile with kernel 2.6.17.4

Some of the modules are not even attempted to be made, so I was wondering what
it is in the make cycle that decides which modules it should try and build?

I get "Making dependencies: please wait...", each module is then compiled but
some are missed out. Is this because the make does not think it has all the
headers needed to compile them?

I had a similar problem with 1.3.6 and fixed this by adding a KERNEL_DIR
environment variable to make; however, this does not seem to help this time.

Many thanks,

Andy Beverley
