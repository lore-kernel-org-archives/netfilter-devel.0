From: Ivan Draga <idraga@gmail.com>
Subject: Connection tracking: snooping RELATED connections
Date: Thu, 13 Jan 2005 22:20:28 +0300
Message-ID: <cf4ab3d505011311202b5c13e1@mail.gmail.com>
Reply-To: Ivan Draga <idraga@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

I have the following question about connection tracking.

Suppose I have a specific application-level protocol that uses a
number of cascading tcp connections to operate. Say it works as
follows: client connects to world-known port on server and sends
port number (e.g. as text). Server connects back to specified
client's port (where client is already listening) and sends another
(server) port number, which client must finally connect to.

Suppose I want to implement connection tracking helper module for
such a strange protocol. I can register helper to detect and snoop the
first connection. When it's created, appropriate expectation for
second (incoming) connection may be queued (so this connection
will be classified as RELATED). And when this expected connection
is created (if it is created at all) I have to spy it to get information
about the third upcoming connection.

But how to do it? Should I register one more ip_conntrack_helper that
will be waiting for the only (second) connection and unregister it
immediately when connection is detected? Would not it be too time /
resource consuming? And what if something goes wrong and the
connection expected is never created, so that expectation will die on
timeout - how would I know to unregister correspondent handler?

Maybe there are simpler ways to do such a things using ip_conntrack
framework?

With best regards,
    Ivan
