From: Ryan Hagelstrom <rhagelstrom@atcorp.com>
Subject: Netfilter Design
Date: Tue, 24 Jun 2003 11:07:45 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <01C33A40.D7C36290.rhagelstrom@atcorp.com>
Reply-To: "rhagelstrom@atcorp.com" <rhagelstrom@atcorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "netfilter-devel@lists.netfilter.org"
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

I'm curious why Netfilter was designed like it was allowing for the 
redirection of IP packets rather than going with a design of a generic 
Intermediate driver that allows the capture and injection of any type of 
packet along with packets that may not have been incoming on the NIC or 
coming down through the stac? It seems the current design works good for 
what it does, but it seems going with an IM design and building netfilter 
as a offshoot of the IM may have been a more generic and a good building 
block for other projects. Take the inability to orgianlly capture ARPs. 
That could have been entirelly avoided if it wasn't so restrictive.

Also, this isn't the only list like this but why on earth in this day and 
age do the archives not have a search feature, but rather download and do 
search yourself. I feel that a lot of the repeat questions and "search the 
archives" responses could be eliminated if it was not so much of a pain in 
the ass to search the archives.

Ryan Hagelstrom
