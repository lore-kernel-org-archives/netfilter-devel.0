From: Devesh Agrawal <devesh.agrawal@gmail.com>
Subject: Newbie question about fragmentation and the PRE_ROUTING hook
Date: Sat, 26 Mar 2005 00:37:41 +0530
Message-ID: <db01ab3505032511079d11ea4@mail.gmail.com>
References: <42403008.9070006@cardvn.net> <42444A4A.5090308@cardvn.net>
Reply-To: Devesh Agrawal <devesh.agrawal@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42444A4A.5090308@cardvn.net>
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
I have a very basic question about netfilter and IP fragments. My
understanding is that the pre routing hook gets the fragmented packet
, which is later in defragged in local in in the ip_local_input funx.
ie If I print the skb in pre route hook, I shall get the individual
frags, whereas in local in hook I would get the complete packet. Is
this absolutely correct ?
Am I gettting the right picture or is there anything else that I should know?
I would be grateful if someone could clear my doubt. 
Sincerely,
Devesh Agrawal
