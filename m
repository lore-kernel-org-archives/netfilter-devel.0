From: fabien.marotte@mindspeed.com
Subject: libnfconntrack and ipv6 addresses
Date: Mon, 17 Sep 2007 09:58:35 +0200
Message-ID: <OF5FF25C0A.554A5909-ONC1257359.002BCCA8-C1257359.002BE42F@mindspeed.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <http://lists.netfilter.org/pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I am developping an application that uses libnfconntrack. I currently try 
to get the ipv6 addresses from a conntrack.

However it seems it is not possible to get the ipv6 address (that is 128 
bits) from the conntrack since the available getter functions are 
nfct_get_attr_u32, nfct_get_attr_u16 and nfct_get_attr_u8.
First question, Is there a way to get the ipv6 addresses with the current 
release?

In case it is not possible, I am going to add the getter for that.
I see several possibilities:

Add a nfct_get_attr_u128 --> will return a pointer on a "malloced" 
structure, not very good I think. Who will free the structure ?
Add a nfct_get_attr_ipv6 --> Will return struct in6_addr , but not very 
generic
Remove const from nfct_get_attr in order to be available by the 
applications that use the library, Not very good since the application 
will have access to a pointer to the conntrack memory space.

What is the better way, according to you to do that ?


Fabien Marotte


Fabien Marotte
System Engineer
+33 (0)4 93 00 69 09
