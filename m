From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Port information.
Date: Mon, 19 Jan 2004 20:52:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <400C277C.8030504@netlab.hut.fi>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

I'm creating a target for which I specify "-p tcp --dport XX" from the 
user-space program. How can I know the port number from the check 
function in the target? Where is it stored? I guess I can't access it 
via the "const struct ipt_entry *e".

          Emmanuel
