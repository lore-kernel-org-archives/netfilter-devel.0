From: Massimiliano Hofer <max@nucleus.it>
Subject: [PATCH 0/4][data-condition]
Date: Tue, 5 Dec 2006 23:12:27 +0100
Message-ID: <200612052312.28824.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
this is an updated version of my priv_data and condition patches.
I tried to follow all of Patrick's suggestions and merged it to the latest 
git.
Unfortunately I had no opportunity to test the compat code for x86_64 (anyway 
I know it compiles). If anyone can try it out I would be very thankful.
The non compat code is fully tested.

Comments are welcome.

-- 
Bye,
   Massimiliano Hofer
