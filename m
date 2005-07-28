From: Robert de Bath <list-netfilter@debath.co.uk>
Subject: Bug Report: IPtables 1.2.* segfaulted by iptables 1.3.*
Date: Thu, 28 Jul 2005 11:53:49 +0100 (BST)
Message-ID: <e756d62eb5442015@mayday.cix.co.uk>
References: <9927912d05072704113d7e8707@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <9927912d05072704113d7e8707@mail.gmail.com>
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

Hi all,
I've been mixing iptables 1.2.8/1.2.11 and 1.3.1/2 tools and unlike I 
would expect I know that the tables created by 1.3.x tools will segfault 
any 1.2.x based tool that's later runon the table.

It appears that this is because iptables 1.3.x no longer sorts the hooked 
chains to the begining of the table. The kernel has no problem with this
but old versions of iptables do.

Is there any reason iptables-1.3 couldn't be changed so it doesn't crash 
version 1.2.x, I assume by putting the sort order back as it was ?

-- 
Rob.                          (Robert de Bath <robert$ @ debath.co.uk>)
                                              <http://www.debath.co.uk/>
