From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: TCP tracking states
Date: Sat, 6 Jul 2002 00:50:35 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207060050.36136@henrik.marasystems.com>
References: <200207060038.59577@henrik.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel <netfilter-devel@lists.samba.org>
In-Reply-To: <200207060038.59577@henrik.marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Saturday 06 July 2002 00.38, Henrik Nordstrom wrote:

> 1. What is the use of LAST_ACK? From what I can tell this state can
> only be reached if the connection is already in the LAST_ACK
> state..

This also seems to be true for the LISTEN state...

Regards
Henrik
