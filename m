From: Gino Velardi <chinua@mac.com>
Subject: [very long] libiptc and Java Native Interface
Date: Sat, 6 Jul 2002 03:26:56 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <7598D377-907F-11D6-AE84-003065B07A30@mac.com>
Mime-Version: 1.0 (Apple Message framework v481)
Content-Type: multipart/mixed; boundary=Apple-Mail-4-366975987
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Apple-Mail-4-366975987
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed

Hi to everyone,
I'm trying to use your libiptc by java native Interface, but I encounter 
some problems.
I wrote two little programs in C (ehm, I copied the one you wrote...:-) 
to add or delete a rule in the input chain. The programs work fine, but 
if I compile them making two shared libs (and after I use their methods 
by JNI), only the "deleting one" works (so I compiled well the shared 
libraries).
The other one notify me an "Invalid Argument" on the iptc_commit().

Can You help me ? (I know that my English is very ugly, sorry....)

I use linux 2.4.2, libiptc 0.1 (I guess), iptables 1.2.5 and java2 vers. 
1.3.1_02.

I acclude the source code of the C program and the output of the shell - 
I have setted on the "dump_entry" option - (you can see the output that 
I get using the C program and the outputs I get using the shared library 
by the JNI program; I have used different version of this shared lib, 
changing the method to add an entry: I used iptc_append_entry, 
iptc_insert_entry and iptc_replace_entry).

I discovered some differences between the output that I get using the C 
code and the output that I get using the shared library: Interface, 
flags and invflags are not null. Why ?

P.S.: to change the C program in a JNI-ready shared lib, I uncomment the 
2 # include and change the "int main()" into "JNIEXPORT void.....", 
after i compile it using "gcc -o libaddrule.so Add.c -liptc 
-I/usr/java/jdk1.3.1._02/include" and after I copy the libaddrule.so in 
the right directory.

Thanx for your time.
I hope you can help me (otherways I've to shift my bachelor).


--Apple-Mail-4-366975987
Content-Disposition: attachment;
	filename=Add.c
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	x-unix-mode=0644;
	name="Add.c"

// sample code appending a new rule to the FORWARD chain in the filter table

//#include "Add.h"
//#include <jni.h>

#include <libiptc/libiptc.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <linux/netfilter.h>

int main()

//JNIEXPORT void JNICALL
//Java_Add_AddRule(JNIEnv *env, jobject obj)
{
        long result = 0;
        iptc_handle_t handle;
        struct ipt_standard_target target;
        struct ipt_entry *chain_entry;
        ipt_chainlabel labelit;



        long size=0;

        /* 	configuring the entry we'll make:
            we want to append a rule to the forward chain in the filter table
            this rule is simple: accept everything that reaches this point in the chain
            */

        printf("size of standard target: %d\n", sizeof(target));
        chain_entry = NULL;


        /* the target of this rule is ACCEPT */
        strncpy(&target.target.u.user.name[0], "DROP", 30);  // other std rules would include DROP etc
        /* set the target size!! */
        target.target.u.user.target_size=sizeof(target);

        chain_entry = malloc(sizeof(struct ipt_entry) + sizeof(target));
        memset(chain_entry, 0, sizeof(chain_entry));  /* zero it out */

        // these could be used to specify ip addresses to be matched for the target, here the src address is being matched
        chain_entry->ip.src.s_addr=inet_addr("143.225.229.6");   /* src address */
                                             chain_entry->ip.smsk.s_addr=inet_addr("255.255.255.255");   /* mask */
                                                                                   chain_entry->ip.dst.s_addr=inet_addr("143.225.229.6");   /* dst address */
                                                                                                                        chain_entry->ip.dmsk.s_addr=inet_addr("255.255.255.255");   /* mask */
                                                                                                                                                              chain_entry->ip.proto=0; /* any protocol */

                                                                                                                                                              printf("ok");
                                                                                                                                                              chain_entry->ip.iniface="";
                                                                                                                                                              printf("ok");
                                                                                                                                                              chain_entry->ip.outiface="";
                                                                                                                                                              printf("ok");
                                                                                                                                                              /* assuming matches do not need to be taken into account, as we are matching everything! */
                                                                                                                                                              size=sizeof(struct ipt_entry);
                                                                                                                                                              printf("sizeof chain_target_offset: %d\n", size);
                                                                                                                                                              chain_entry->target_offset=size;
                                                                                                                                                              chain_entry->next_offset= size + sizeof(target);    /* next target is the next rule (offset is size of current entry) */
                                                                                                                                                              printf("value of chain entry next offset: %d\n", chain_entry->next_offset);

                                                                                                                                                              memcpy(chain_entry->elems, &target, sizeof(target));


                                                                                                                                                              /* standard is the name given to any of the system defined targets, like DROP, ACCEPT, REJECT, QUEUE, RETURN */





                                                                                                                                                              handle = iptc_init("filter");    /* check if table is loaded */
                                                                                                                                                                                 if (handle == NULL)
                                                                                                                                                                                 {
                                                                                                                                                                                     printf("error: table not loaded!\n");
                                                                                                                                                                                     exit(0);
                                                                                                                                                                                 }
                                                                                                                                                                                 else
                                                                                                                                                                                 {
                                                                                                                                                                                     printf("table exists\n");
                                                                                                                                                                                 }
                                                                                                                                                                                 result = iptc_is_chain("INPUT", handle);
                                                                                                                                                                                 if(result)                              {
                                                                                                                                                                                     printf("chain exists\n");
                                                                                                                                                                                 }
                                                                                                                                                                                 else
                                                                                                                                                                                 {
                                                                                                                                                                                     printf("error: chain does not exist!\n");
                                                                                                                                                                                     exit(0);
                                                                                                                                                                                 }

                                                                                                                                                                                 // set the name of the chain we want to append to
                                                                                                                                                                                 strncpy(&labelit, "INPUT", 30);

                                                                                                                                                                                 result = iptc_append_entry(labelit, chain_entry, &handle);
                                                                                                                                                                                 if(result == 0)
                                                                                                                                                                                 printf("append error: %s\n", iptc_strerror(errno));

                                                                                                                                                                                 result=iptc_commit(&handle);
                                                                                                                                                                                 if(result == 0)
                                                                                                                                                                                 printf("commit error: %s\n", iptc_strerror(errno));
                                                                                                                                                                                 else
                                                                                                                                                                                 printf("appended new rule to block successfully\n");

                                                                                                                                                                                 free(chain_entry);
                                                                                                                                                                                 return 0;
}

--Apple-Mail-4-366975987
Content-Disposition: attachment;
	filename=Add.h
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	x-unix-mode=0644;
	name="Add.h"

/* DO NOT EDIT THIS FILE - it is machine generated */
#include <jni.h>
/* Header for class Add */

#ifndef _Included_Add
#define _Included_Add
#ifdef __cplusplus
extern "C" {
#endif
/*
 * Class:     Add
 * Method:    AddRule
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_Add_AddRule
  (JNIEnv *, jobject);

#ifdef __cplusplus
}
#endif
#endif

--Apple-Mail-4-366975987
Content-Disposition: attachment;
	filename=Add.java
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	x-unix-mode=0644;
	name="Add.java"

//
//  Add.java
//  

public class Add {

    public native void AddRule();

    static {
        System.loadLibrary("Add");
    }

    public static void main(String[] args){
        new Add().AddRule();
    }
}

--Apple-Mail-4-366975987
Content-Disposition: attachment;
	filename=test.text
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	x-unix-mode=0644;
	name="test.text"


-- program written in C --
[root@ns velardi]# ./a.out
size of standard target: 36
sizeof chain_target_offset: 112
value of chain entry next offset: 148
table exists
chain exists
TC_COMMIT: Checking entries...OK
libiptc v1.2.5.  5 entries, 768 bytes.
Table `filter'
Hooks: pre/in/fwd/out/post = 0/0/296/444/0
Underflows: pre/in/fwd/out/post = 148/148/296/444/148
Entry 0 (0):
SRC IP: 143.225.229.6/255.255.255.255
DST IP: 143.225.229.6/255.255.255.255
Interface: `'/................to `'/................
Protocol: 0
Flags: 00
Invflags: 00
Counters: 0 packets, 0 bytes
Cache: 00000000
Target name: `' [36]
verdict=NF_DROP

Entry 1 (148):
SRC IP: 0.0.0.0/0.0.0.0
DST IP: 0.0.0.0/0.0.0.0
Interface: `'/................to `'/................
Protocol: 0
Flags: 00
Invflags: 00
Counters: 62930 packets, 15670922 bytes
Cache: 00000000
Target name: `' [36]
verdict=NF_ACCEPT

Entry 2 (296):
SRC IP: 0.0.0.0/0.0.0.0
DST IP: 0.0.0.0/0.0.0.0
Interface: `'/................to `'/................
Protocol: 0
Flags: 00
Invflags: 00
Counters: 0 packets, 0 bytes
Cache: 00000000
Target name: `' [36]
verdict=NF_ACCEPT

Entry 3 (444):
SRC IP: 0.0.0.0/0.0.0.0
DST IP: 0.0.0.0/0.0.0.0
Interface: `'/................to `'/................
Protocol: 0
Flags: 00
Invflags: 00
Counters: 13215 packets, 1949697 bytes
Cache: 00000000
Target name: `' [36]
verdict=NF_ACCEPT

Entry 4 (592):
SRC IP: 0.0.0.0/0.0.0.0
DST IP: 0.0.0.0/0.0.0.0
Interface: `'/................to `'/................
Protocol: 0
Flags: 00
Invflags: 00
Counters: 0 packets, 0 bytes
Cache: 00000000
Target name: `ERROR' [64]
error=`ERROR'

appended new rule to block successfully                                      

-- by the JNI ( I used the "iptc_insert_entry" or the "iptc_replace_entry" method) --
[root@ns velardi]# java Add
size of standard target: 36
sizeof chain_target_offset: 112
value of chain entry next offset: 148
table exists
chain exists
TC_COMMIT: Checking entries...OK
libiptc v1.2.5.  5 entries, 768 bytes.
Table `filter'
Hooks: pre/in/fwd/out/post = 0/0/296/444/0
Underflows: pre/in/fwd/out/post = 148/148/296/444/148
Entry 0 (0):
SRC IP: 143.225.229.6/255.255.255.255
DST IP: 143.225.229.6/255.255.255.255
Interface: `: JNI_OnLoad'/XXXXXXXXXXXXXXXXto `r/java/jdk1.3.1_02/jre/lib/i386/native_threads/l'/XXXXXXXXXXXXXXXX
Protocol: 0
Flags: 68
Invflags: 70
Counters: 356482287104 packets, 309237647616 bytes
Cache: 6F732E69 IP_SRC IP_IF_OUT IP_PROTO IP_OPTIONS IP_SRC_PT IP_DST_PT IP_PROTO_UNKNOWN
Target name: `' [36]
verdict=NF_DROP

Entry 1 (148):
SRC IP: 0.0.0.0/0.0.0.0
DST IP: 0.0.0.0/0.0.0.0
Interface: `'/................to `'/................
Protocol: 0
Flags: 00
Invflags: 00
Counters: 63053 packets, 15687581 bytes
Cache: 00000000
Target name: `' [36]
verdict=NF_ACCEPT


[cut]


commit error: Target problem

-- by JNI (I used the "iptc_append_entry" method) --

[root@ns velardi]# java Add
size of standard target: 36
sizeof chain_target_offset: 112
value of chain entry next offset: 148
table exists
chain exists
TC_COMMIT: Checking entries...OK
libiptc v1.2.5.  5 entries, 768 bytes.
Table `filter'
Hooks: pre/in/fwd/out/post = 0/0/296/444/0
Underflows: pre/in/fwd/out/post = 148/148/296/444/148
Entry 0 (0):
SRC IP: 143.225.229.6/255.255.255.255
DST IP: 143.225.229.6/255.255.255.255
Interface: `: JNI_OnLoad'/XXXXXXXXXXXXXXXXto `r/java/jdk1.3.1_02/jre/lib/i386/native_threads/l'/XXXXXXXXXXXXXXXX
Protocol: 0
Flags: 68
Invflags: 70
Counters: 0 packets, 0 bytes
Cache: 6F732E69 IP_SRC IP_IF_OUT IP_PROTO IP_OPTIONS IP_SRC_PT IP_DST_PT IP_PROTO_UNKNOWN
Target name: `' [36]
verdict=NF_DROP

Entry 1 (148):
SRC IP: 0.0.0.0/0.0.0.0
DST IP: 0.0.0.0/0.0.0.0
Interface: `'/................to `'/................
Protocol: 0
Flags: 00
Invflags: 00
Counters: 63142 packets, 15703308 bytes
Cache: 00000000
Target name: `' [36]
verdict=NF_ACCEPT


[cut]


commit error: Invalid argument
--Apple-Mail-4-366975987
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed




I've seen things you people wouldn't believe. Attack ships on fire off 
the shoulder of Orion. I watched C-beams glitter in the dark near the 
Tannhauser gate. All those moments will be lost in time, like tears in 
rain. Time to die.


--Apple-Mail-4-366975987--
