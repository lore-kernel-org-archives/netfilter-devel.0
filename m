From: Patrick McHardy <kaber@trash.net>
Subject: Re: [BK PATCH] Fix ip_conntrack_amanda data corruption bug that
 breaks amanda dumps
Date: Thu, 04 Nov 2004 19:55:07 +0100
Message-ID: <418A7B0B.7040803@trash.net>
References: <20041104121522.GA16547@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-net@vger.kernel.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Matthias Andree <matthias.andree@gmx.de>
In-Reply-To: <20041104121522.GA16547@merlin.emma.line.org>
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

Matthias Andree wrote:

>You can use "bk receive" to patch with this mail.
>
>BK: Parent repository is bk://linux.bkbits.net/linux-2.5
>
>Patch description:
>ChangeSet@1.2427, 2004-11-04 13:00:54+01:00, matthias.andree@gmx.de
>    Fix ip_conntrack_amanda data corruption bug that breaks amanda dumps.
>  
>    Fix a bug where the ip_conntrack_amanda module replaces the first LF
>    after "CONNECT " by a NUL byte. This causes the UDP checksum to become
>    corrupt and strips off the OPTIONS argument from the received packet,
>    breaking amanda's sendbackup component altogether.  Replace the LF
>    character before releasing the buffer.
>  
>
The data that is changed is only a copy, the actual packet is not touched.

Regards
Patrick

>  
>    Signed-off-by: Matthias Andree <matthias.andree@gmx.de>
>
>Matthias Andree
>
>------------------------------------------------------------------------
>
>##### DIFFSTAT #####
> ip_conntrack_amanda.c |   12 ++++++++----
> 1 files changed, 8 insertions(+), 4 deletions(-)
>
>##### GNUPATCH #####
>--- 1.10/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-08-19 02:14:53 +02:00
>+++ 1.11/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-11-04 12:59:26 +01:00
>@@ -49,7 +49,7 @@
> {
> 	struct ip_conntrack_expect *exp;
> 	struct ip_ct_amanda_expect *exp_amanda_info;
>-	char *amp, *data, *data_limit, *tmp;
>+	char *amp, *data, *data_limit, *tmp, *le = 0;
> 	unsigned int dataoff, i;
> 	u_int16_t port, len;
> 
>@@ -83,9 +83,10 @@
> 		goto out;
> 	data += strlen("CONNECT ");
> 
>-	/* Only search first line. */	
>-	if ((tmp = strchr(data, '\n')))
>-		*tmp = '\0';
>+	/* Only search first line.
>+	 * NB: The change to the data must be reverted later! */
>+	if ((le = strchr(data, '\n')))
>+		*le = '\0';
> 
> 	for (i = 0; i < ARRAY_SIZE(conns); i++) {
> 		char *match = strstr(data, conns[i]);
>@@ -120,6 +121,9 @@
> 	}
> 
> out:
>+	/* replace LF character to repair the packet */
>+	if (le)
>+	    *le = '\n';
> 	UNLOCK_BH(&amanda_buffer_lock);
> 	return NF_ACCEPT;
> }
>
>  
>
