From: Ryan Hagelstrom <rhagelstrom@atcorp.com>
Subject: libIPQ Questions
Date: Wed, 11 Dec 2002 14:16:21 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <01C2A11F.E1F0ADA0.rhagelstrom@atcorp.com>
Reply-To: "rhagelstrom@atcorp.com" <rhagelstrom@atcorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'netfilter-devel@lists.netfilter.org'"
	 <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,

I'm in the works to write a module using netfilter. However I'm wondering 
if I would be able to use libIPQ to simply some of the project.
I need to write a module that is able to mangle and route packets between 
two different network interfaces along with inject certain custom 
management and configuration packets to the specific network interface. I'm 
just curious if one is able to this using libIPQ or would the approach 
involve just writing it all in a netfilter module. I'm guessing the answer 
is the latter but I wanted to double check. If doing this in libIPQ is 
possible if someone could provide an example it would be appreciated.

Or if I'm missing something and there is an alternative approach I'm open 
to suggestions.

Thanks

Ryan Hagelstrom
