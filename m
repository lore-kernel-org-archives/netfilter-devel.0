From: Philip Craig <philipc@snapgear.com>
Subject: [PATCH] conntrack: Fix option parsing for ARM
Date: Fri, 12 May 2006 17:11:27 +1000
Message-ID: <4464351F.6000402@snapgear.com>
References: <ca021ab30604270455q5cf093c9s990558209bca3e1d@mail.gmail.com>	<20060501175353.GD5267@rama>	<ca021ab30605030249s62ab1924uf9b1be924bd2d28e@mail.gmail.com>	<20060503111549.GO16562@sunbeam.de.gnumonks.org>	<ca021ab30605090806l791e6f3dl7354bd789df209ee@mail.gmail.com>	<4460B14E.90506@eurodev.net>
	<ca021ab30605100118u16675c7au933a464ebe64d705@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070100000604090707080602"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?ISO-8859-1?Q?S=E9bastien_LAVEZE?= <slaveze@gmail.com>,
	Pablo Neira Ayuso <pablo@eurodev.net>
In-Reply-To: <ca021ab30605100118u16675c7au933a464ebe64d705@mail.gmail.com>
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

This is a multi-part message in MIME format.
--------------070100000604090707080602
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/10/2006 06:18 PM, S=E9bastien LAVEZE wrote:
> I have problem using the conntrack utility...
> It always display the help message and i get the message
> conntrack v1.00beta2: Missing arguments...

The result of getopt_long() was assigned to a char,
which defaults to unsigned on ARM, so the comparison
against -1 always failed.

--------------070100000604090707080602
Content-Type: text/plain;
 name="conntrack-getopt.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="conntrack-getopt.patch"

Index: conntrack/src/conntrack.c
===================================================================
--- conntrack/src/conntrack.c	(revision 6601)
+++ conntrack/src/conntrack.c	(working copy)
@@ -602,7 +602,7 @@
 
 int main(int argc, char *argv[])
 {
-	char c;
+	int c;
 	unsigned int command = 0, options = 0;
 	unsigned int type = 0, event_mask = 0;
 	unsigned int l3flags = 0, l4flags = 0, metaflags = 0;

--------------070100000604090707080602--
