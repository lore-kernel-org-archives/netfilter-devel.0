From: XiChimos <xichimos@plobe.com>
Subject: Buffer size
Date: Tue, 20 Jan 2004 13:34:56 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <400D74D0.8040303@plobe.com>
References: <20040120011305.GD1142@eychenne.org> <Pine.LNX.4.44.0401200743490.23963-100000@filer.marasystems.com> <20040120232103.GB1143@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20040120232103.GB1143@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I was looking at the code for a userspace application and noticed that 
the buffer size was 2048.  Why is it this value if the maximum size of a 
IP datagram is 65535?  Does it get fragmented after the point of 2048 
octects?  Finally, will using 2048 ever get me into trouble?

Chris
