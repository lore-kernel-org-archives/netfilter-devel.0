From: "Damiano Bolzoni" <damiano.bolzoni@tin.it>
Subject: How to close a sock?
Date: Tue, 11 Jun 2002 23:25:05 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <000501c2118e$74e1f9b0$32907450@CHICCA>
Reply-To: "Damiano Bolzoni" <damiano.bolzoni@tin.it>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,
I've posted some days ago about a problem with a lkm.
I'm trying to close all the sock that remain too much time in SYN_RECV
state.
This is how I obtain a pointer to each of them:

tcp_listen_lock();

for(i = 0; i < TCP_LHTABLE_SIZE; i++)

{

sk_copy = tcp_listening_hash[i];

while(sk_copy != NULL)

{

tp = &(sk_copy->tp_pinfo.af_tcp);

read_lock_bh(&tp->syn_wait_lock);

lopt = tp->listen_opt;

if (lopt && lopt->qlen != 0)

{

for (k=0; k<TCP_SYNQ_HSIZE; k++)

{

req = lopt->syn_table[k];

while(req != NULL)

{

req = req->dl_next;

// here I want to use tcp_synq_drop...but my system crashes!!!

num++;

}

}

}

read_unlock_bh(&tp->syn_wait_lock);

num++;

sk_copy = sk_copy->next;

}

}

tcp_listen_unlock();



How can I do it?

Thanx

damiano

damiano.bolzoni@tin.it
