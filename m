From: Jeremy Kerr <jeremy@redfishsoftware.com.au>
Subject: [ANNOUNCE] nfsim - netfilter simulation environment
Date: Wed, 7 Jan 2004 10:44:17 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401071044.18059.jeremy@redfishsoftware.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Rusty and I have been working on a simulation enviroment ("nfsim") to 
facilitate netfilter testing. It provides a simulated kernel enviroment to 
build and run netfilter code in userspace, and a command-line interface to 
conduct tests.

nfsim is available from:

 http://ozlabs.org/~jk/projects/nfsim/

Have a look through the testsuite directory file for an example of a testing 
script. Also, inline help is available from the CLI.

Contributions & comments are most welcome.


Jeremy
