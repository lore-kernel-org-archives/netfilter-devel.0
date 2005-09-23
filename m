From: "Vincent" <cs83152@csie.chu.edu.tw>
Subject: What is the comparing sequence of user defined module?
Date: Fri, 23 Sep 2005 19:23:43 +0800
Message-ID: <001901c5c031$463eabd0$aa0ba8c0@l7.com.tw>
References: <20050923101704.GA5090@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20050923101704.GA5090@roonstrasse.net>
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

Hello folks,

I am trying to know what is the ordering of module comparing  in the
kernel.
Is it by alphabet of module name? Or by loading module sequence?

What I want to know is the comparing sequence of do_match function in
the ip_tables.c ?

Thanks in advance


Vincent
